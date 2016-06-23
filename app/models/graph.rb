class Graph
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  has_many :links, :class_name => 'Link'
  has_many :nodes, :class_name => 'Node'
end