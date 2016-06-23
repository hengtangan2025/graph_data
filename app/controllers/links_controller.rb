class LinksController < ApplicationController
  def new
    
  end

  def index
    
  end

  def create
    if Node.where(:name => params[:link][:input_node_name]).all.count == 0
      input_node = Node.create(:name => params[:link][:input_node_name])
    else
      input_node = Node.where(:name => params[:link][:input_node_name]).all.first
    end

    if Node.where(:name => params[:link][:output_node_name]).all.count == 0
      output_node = Node.create(:name => params[:link][:output_node_name])
    else
      output_node = Node.where(:name => params[:link][:output_node_name]).all.first
    end

    link = Link.create(:input_node_id => input_node.id, :output_node_id => output_node.id, :kind => params[:link][:kind])

    if link.save
      if request.xhr? == 0
        render :text => "保存成功"
      else
        redirect_to "/links/new",:notice => '保存成功'
      end
    else
      redirect_to "/links/new",:notice => link.errors
    end
  end

  def update
    
  end

  def edit
    
  end

  def destroy
    graph = Graph.find(params[:graph_id])
    link = Link.find(params[:id])
    link.destroy
    redirect_to "/graphs/#{graph.id}",:notice => '删除成功'
  end
end