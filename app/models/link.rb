class Link
  extend Enumerize
  KIND_EXPECTED   = 'expected'
  KIND_ACTUAL = 'actual'

  include Mongoid::Document
  include Mongoid::Timestamps

  enumerize :kind, in: [:expected, :actual]
  field :input_node_id, :type => String
  field :output_node_id, :type => String
  belongs_to :graph, :class_name => 'Graph'
end