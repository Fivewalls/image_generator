require 'pry'
require 'action_view'
require 'action_controller'
require 'slim'
require 'base64'
require 'imgkit'

module ImageGenerator
  class Base
    include ActionView::Helpers::AssetTagHelper

    CATEGORIES = [RATING = 'rating'.freeze, REVIEWS = 'reviews'.freeze].freeze

    attr_reader :options

    def initialize(options={})
      # :width, :height, :category, :rating, :rating_round, :reviews_count
      @options = options
      @options[:width]  ||= 1_500
      @options[:height] ||= 400
    end

    def call
      validate!

      perform
    rescue => e
      raise Errors::Error, e
    end

  private

    def perform
      view = ActionView::Base.new(nil, {}, ActionController::Base.new)
      html = view.render(hash_to_render)
      kit = ::IMGKit.new(html, width: options[:width], height: options[:height], quality: 100)
      kit.to_png
    end

    def validate!
      raise Errors::InvalidOption, "Category should be one of: #{CATEGORIES}" unless options[:category].in?(CATEGORIES)
      case options[:category]
      when RATING
        raise Errors::InvalidOption, "Param `rating` is blank" if options[:rating].blank?
      when REVIEWS
        raise Errors::InvalidOption, "Param `reviews_count` is blank" if options[:reviews_count].blank?
      end
    end

    def hash_to_render
      case options[:category]
      when RATING
        {
          file: File.expand_path('../../views/categories/rating.slim', __FILE__),
          locals: {
            rating: options[:rating].round(options[:rating_round] || 1),
            rating_back_image: rating_back_image,
            width: options[:width],
            height: options[:height]
          }
        }
      when REVIEWS
        {
          file: File.expand_path('../../views/categories/reviews.slim', __FILE__),
          locals: {
            reviews_count: options[:reviews_count].to_i,
            reviews_back_image: reviews_back_image,
            width: options[:width],
            height: options[:height]
          }
        }
      end
    end

    def rating_back_image
      path = File.expand_path('../../assets/images/wall.png', __FILE__)
      image_tag_base64(file_path: path, options: { width: options[:width], height: options[:height] })
    end

    def reviews_back_image
      path = File.expand_path('../../assets/images/wall.png', __FILE__)
      image_tag_base64(file_path: path, options: { width: options[:width], height: options[:height] })
    end

    def image_tag_base64(file_path:, mime_type: 'image/jpeg', options: {})
      image_tag("data:#{mime_type};base64,#{Base64.encode64(open(file_path) { |io| io.read })}", options)
    end
  end
end
