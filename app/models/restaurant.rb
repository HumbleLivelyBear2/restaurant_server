class Restaurant < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  belongs_to :area
  # belongs_to :category
  
  has_many :restaurant_type_ships
  has_many :types, :through => :restaurant_type_ships

  has_many :restaurant_category_rank_ships
  has_many :categories, :through => :restaurant_category_rank_ships

  scope :index_select, select("id,name,grade_food,grade_service,pic_url")

  
  def self.search(params)
    tire.search(page: params[:page], per_page: 10, load: true) do
      query{ string params[:keyword], default_operator: "AND"}
    end
  end

  mapping do
    indexes :name, :analyzer => "cjk"	
  end

end
