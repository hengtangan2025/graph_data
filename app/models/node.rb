class Node
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  belongs_to :graph,  :class_name => 'Graph'
end