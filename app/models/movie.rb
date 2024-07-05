class Movie < ApplicationRecord
    before_save :set_slug
    
    has_many :reviews, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :fans, through: :favorites, source: :user
    has_many :characterizations, dependent: :destroy
    has_many :genres, through: :characterizations
    
    RATINGS = %w(G PG PG-13 R NC-17)
    validates :title, presence: true,uniqueness: true
    validates :title, :duration, :released_on, presence: true
    validates :description, length: {minimum: 25}
    validates :total_gross, numericality: {greater_than_or_equal_to: 0}
    validates :image_file_name, format: {
        with: /\w+\.(jpg|png)\z/i,
        message: "must be a JPG or PNG image"
    }
    validates :rating, inclusion: { in: RATINGS }
    scope :released, -> {where("released_on < ?", Time.now ).order(released_on: :desc)}
    scope :upcoming, -> { where("released_on > ?", Time.now).order(released_on: :asc)} 
    scope :recent, ->(max=5) { released.limit(max)}

    def flop?
        return false if reviews.count>50 && average_stars>=4
        total_gross.to_i<225000000 || total_gross.blank?
    end

    def average_stars
        reviews.average(:stars)            
    end

    def average_stars_as_percent
        (self.average_stars / 5.0) * 100
    end

    def set_slug
        self.slug = title.parameterize
    end
    
    def to_param
        slug
    end
end
