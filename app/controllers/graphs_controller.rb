class GraphsController < ApplicationController
  def new
    
  end

  def index
    
  end

  def create
    graph = Graph.create(:name => params[:graph][:name])

    if graph.save
      redirect_to "/graphs/#{graph.id}"
    end
  end

  def show
    @graph = Graph.find(params[:id])
  end

  def update
    
  end

  def add_link
    @graph = Graph.find(params[:id])
    if @graph.nodes.where(:name => params[:input_node]).all.count == 0
      input_node = @graph.nodes.create(:name => params[:input_node])
    else
      input_node = @graph.nodes.where(:name => params[:input_node]).all.first
    end

    if @graph.nodes.where(:name => params[:output_node]).all.count == 0
      output_node = @graph.nodes.create(:name => params[:output_node])
    else
      output_node = @graph.nodes.where(:name => params[:output_node]).all.first
    end

    link = @graph.links.create(:input_node_id => input_node.id, :output_node_id => output_node.id, :kind => params[:link_kind])

    if link.save
      html = render_to_string :partial => "/graph_links/link_li", :locals => {:link => link}
      return render :text => html
    end
    render :status => 500
  end

  def edit_link
    link = LInk.find(params[:id])
    input_node = Node.where(:name => params[:input_node]).all.first
    output_node = Node.where(:name => params[:output_node]).all.first
    link.update(:input_node_id => input_node.id, :output_node_id => output_node.id, :kind => params[:link_kind])
  end

  def query_links
    links_array = []
    outport_array =  []
    query_links_from_A_to_B(links_array,outport_array,params[:first_node],params[:last_node],params[:id])
    links_array = links_array.uniq
    render :json => {:result => links_array.to_json}
  end

  def query_links_from_A_with_length
    links_array = []
    outport_array =  []
    get_next_port_to_length(links_array,outport_array,params[:first_node],params[:length],params[:id])
    links_array = links_array.uniq
    render :json => {:result => links_array.to_json}
  end

  def query_links_to_B_with_length
    links_array = []
    inport_array =  []
    get_before_port_to_length(links_array,inport_array,params[:last_node],params[:length],params[:id])
    links_array = links_array.uniq
    render :json => {:result => links_array.to_json}
  end

  def destroy
    
  end

  private
    def query_links_from_A_to_B(links_array,outport_array,first_node_name,last_node_name,graph_id)
      obj = {}
      graph = Graph.find(graph_id)
      first_node = Node.where(:name => first_node_name).all.first
      last_node = Node.where(:name => last_node_name).all.first
      get_links = graph.links.where(:input_node_id => first_node.id.to_s).all.to_a
      get_links.each do |link|
        link_outport = Node.find(link.output_node_id)
        obj[:link_outport] = outport_array
        hash = {}
        input_node = Node.find(link.input_node_id)
        hash[:inPortName] = input_node.name
        output_node = Node.find(link.output_node_id)
        hash[:outPortName] = output_node.name
        hash[:kind] = link.kind
        if get_links.length != 0
          if link_outport.name == last_node_name
            obj[:link_outport].push(hash)
            array_length = obj[:link_outport].length - 1
            (0..array_length).each do |i|
              links_array.push(obj[:link_outport][i])
            end
          else
            next_array = []
            array_length = obj[:link_outport].length - 1
            (0..array_length).each do |i|
              next_array.push(obj[:link_outport][i])
            end 
            next_array.push(hash)
            query_links_from_A_to_B(links_array,next_array,link_outport.name,last_node_name,graph_id)
          end
        end
      end
    end

    def get_next_port_to_length(links_array,outport_array,first_node_name,length,graph_id)
      obj = {}
      graph = Graph.find(graph_id)
      first_node = Node.where(:name => first_node_name).all.first
      get_links = graph.links.where(:input_node_id => first_node.id.to_s).all.to_a
      get_links.each do |link|
        p 1111111111111
        p link.id
        link_outport = Node.find(link.output_node_id)
        p 2222222222222
        p link_outport
        obj[:link_outport] = outport_array
        p 33333333333
        p obj[:link_outport]
        hash = {}
        input_node = Node.find(link.input_node_id)
        hash[:inPortName] = input_node.name
        output_node = Node.find(link.output_node_id)
        hash[:outPortName] = output_node.name
        hash[:kind] = link.kind
        if get_links.length != 0
          if obj[:link_outport].length + 1 == length.to_i
            obj[:link_outport].push(hash)
            array_length = obj[:link_outport].length - 1
            (0..array_length).each do |i|
              links_array.push(obj[:link_outport][i])
            end
            obj[:link_outport].delete(hash)
          else
            if obj[:link_outport].length + 1 < length.to_i
              next_array = []
              array_length = obj[:link_outport].length - 1
              (0..array_length).each do |i|
                next_array.push(obj[:link_outport][i])
              end 
              next_array.push(hash)
              get_next_port_to_length(links_array,next_array,link_outport.name,length,graph_id)
            end
          end
        end
      end
    end

    def get_before_port_to_length(links_array,inport_array,last_node_name,length,graph_id)
      obj = {}
      graph = Graph.find(graph_id)
      last_node = Node.where(:name => last_node_name).all.first
      get_links = graph.links.where(:output_node_id => last_node.id.to_s).all.to_a
      get_links.each do |link|
        link_inport = Node.find(link.input_node_id)
        obj[:link_inport] = inport_array
        hash = {}
        input_node = Node.find(link.input_node_id)
        hash[:inPortName] = input_node.name
        output_node = Node.find(link.output_node_id)
        hash[:outPortName] = output_node.name
        hash[:kind] = link.kind
        if get_links.length != 0
          if obj[:link_inport].length + 1 == length.to_i
            obj[:link_inport].push(hash)
            array_length = obj[:link_inport].length - 1
            (0..array_length).each do |i|
              links_array.push(obj[:link_inport][i])
            end
            obj[:link_inport].delete(hash)
          else
            if obj[:link_inport].length + 1 < length.to_i
              next_array = []
              array_length = obj[:link_inport].length - 1
              (0..array_length).each do |i|
                next_array.push(obj[:link_inport][i])
              end 
              next_array.push(hash)
              get_before_port_to_length(links_array,next_array,link_inport.name,length,graph_id)
            end
          end
        end
      end
    end
end