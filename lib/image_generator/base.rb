require 'pry'
require 'action_view'
require 'action_controller'
require 'slim'
require 'base64'
require 'imgkit'

module ImageGenerator
  class Base
    include ActionView::Helpers::AssetTagHelper

    CATEGORIES = [PROFILE = 'profile'.freeze, RATING = 'rating'.freeze, REVIEWS = 'reviews'.freeze].freeze

    attr_reader :options

    def initialize(options={})
      # :width, :height, :category, :rating, :rating_round, :reviews_count, :name, :photo_url
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
      when PROFILE
        raise Errors::InvalidOption, "Param `name` is blank" if options[:name].blank?
        raise Errors::InvalidOption, "Param `photo_url` is blank" if options[:photo_url].blank?
      when RATING
        raise Errors::InvalidOption, "Param `rating` is blank" if options[:rating].blank?
      when REVIEWS
        raise Errors::InvalidOption, "Param `reviews_count` is blank" if options[:reviews_count].blank?
      end
    end

    def hash_to_render
      case options[:category]
      when PROFILE
        {
          file: File.expand_path('../../views/categories/profile.slim', __FILE__),
          locals: {
            name: options[:name],
            photo: profile_image,
            logo: logo_image,
            profile_back_image: profile_back_image,
            width: options[:width],
            height: options[:height]
          }
        }
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

    def logo_image
      path = File.expand_path('../../assets/images/logo.png', __FILE__)
      image_tag_base64(file_path: path)
    end

    def profile_image
      image_tag_base64(file_path: options[:photo_url])
    end

    def profile_back_image
      path = File.expand_path('../../assets/images/quiz-background.png', __FILE__)
      image_tag_base64(file_path: path, options: { width: options[:width], height: options[:height] })
    end

    def rating_back_image
      path = File.expand_path('../../assets/images/wall-background.png', __FILE__)
      image_tag_base64(file_path: path, options: { width: options[:width], height: options[:height] })
    end

    def reviews_back_image
      path = File.expand_path('../../assets/images/agent-profile-header-desktop.png', __FILE__)
      image_tag_base64(file_path: path, options: { width: options[:width], height: options[:height] })
    end

    def image_tag_base64(file_path:, mime_type: 'image/jpeg', options: {})
      image_tag("data:#{mime_type};base64,#{Base64.encode64(open(file_path) { |io| io.read })}", options)
    end
  end
end
