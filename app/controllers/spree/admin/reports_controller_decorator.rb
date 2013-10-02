Spree::Admin::ReportsController.class_eval do
  def shipped_weekly
    params[:q] ||= { week: Date.today.strftime('%W').to_i + 1, year: Date.today.year }

    unless params[:q][:week].blank?
      params[:q][:year] = Date.today.year if params[:q][:year].blank?

      params[:q][:week] = params[:q][:week].to_i
      params[:q][:year] = params[:q][:year].to_i

      params[:q][:shipped_at_gt] = DateTime.commercial(params[:q][:year], params[:q][:week], 1).in_time_zone(Time.zone).beginning_of_day
      params[:q][:shipped_at_lt] = DateTime.commercial(params[:q][:year], params[:q][:week], 1).in_time_zone(Time.zone).end_of_week
    else
      if params[:q][:shipped_at_gt].blank?
        params[:q][:shipped_at_gt] = Time.zone.now.beginning_of_month
      else
        params[:q][:shipped_at_gt] = Time.zone.parse(params[:q][:shipped_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
      end

      if params[:q] && !params[:q][:shipped_at_lt].blank?
        params[:q][:shipped_at_lt] = Time.zone.parse(params[:q][:shipped_at_lt]).end_of_day rescue ''
      end
    end

    @search = Spree::Shipment.shipped.ransack(params[:q])
    @shipments = @search.result

    unless params[:q][:week].blank?
      params[:q][:shipped_at_gt] = nil
      params[:q][:shipped_at_lt] = nil
    end

    @totals = {}

    @shipments.each do |shipment|
      shipment.line_items.each do |item|
        @totals[item.variant_id] = { sku: item.variant.sku, name: item.variant.name, amount: 0 } unless @totals.has_key?(item.variant_id)
        @totals[item.variant_id][:amount] += item.quantity
      end
    end
  end
end

Spree::Admin::ReportsController::AVAILABLE_REPORTS[:shipped_weekly] = { name: Spree.t(:shipped_weekly, scope: :weekly_reports), description: Spree.t(:shipped_weekly_description, scope: :weekly_reports) }
