# frozen_string_literal: true

# Booking list component for displaying booking data
#
# Usage:
#   <%= rui :booking_list do |list| %>
#     <% list.with_booking(
#       status: "Upcoming",
#       guest: "John Doe",
#       guest_counts: "2 adults, 1 child",
#       arrival: "Aug 24, 2024",
#       departure: "Aug 28, 2024",
#       booking_date: "June, 2024",
#       booking_date_time: "7:38 PM CST",
#       property: "Mountain Vista Chalet",
#       price: "$1,165.45"
#     ) %>
#   <% end %>
module Rui
  class BookingListComponent < DatalistComponent
    renders_many :bookings, BookingItemComponent

    def initialize(**html_options)
      super(**html_options)
    end
  end

  class BookingItemComponent < BaseComponent
    def initialize(
      status:,
      guest:,
      guest_counts:,
      arrival:,
      departure:,
      booking_date:,
      booking_date_time:,
      property:,
      price:,
      **html_options
    )
      @status = status
      @guest = guest
      @guest_counts = guest_counts
      @arrival = arrival
      @departure = departure
      @booking_date = booking_date
      @booking_date_time = booking_date_time
      @property = property
      @price = price
      @html_options = html_options
    end

    attr_reader :status, :guest, :guest_counts, :arrival, :departure, :booking_date, :booking_date_time, :property, :price

    private

    def status_classes
      case status
      when "Complete"
        "bg-emerald-50 text-emerald-600 dark:bg-emerald-500/20 dark:text-emerald-200"
      when "Canceled"
        "bg-red-50 text-red-600 dark:bg-red-500/20 dark:text-red-200"
      when "Upcoming"
        "bg-blue-50 text-blue-600 dark:bg-blue-500/20 dark:text-blue-200"
      else
        "bg-gray-50 text-gray-600 dark:bg-gray-500/20 dark:text-gray-200"
      end
    end
  end
end