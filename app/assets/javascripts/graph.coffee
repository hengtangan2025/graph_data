class Graph
  constructor: (@$eml) ->
    @bind_event()

  bind_event: -> 
    @$eml.on "click", ".add-links .add-button",=>
      graph_id = jQuery(".add-links").data("graph-id")
      input_node_name = jQuery(".add-links .input-node-name").val()
      output_node_name = jQuery(".add-links .output-node-name").val()
      kind = jQuery(".add-links .kind").val()
      jQuery.ajax
        url: "/graphs/#{graph_id}/add_link",
        method: 'post',
        data: {
          input_node: input_node_name,
          output_node: output_node_name,
          link_kind: kind
        }
        type: 'html'
      .success (html) =>
        @$eml.find("ul.links").append(html)
        alert('增加成功')

    @$eml.on "click", ".query-all-links-from-A-to-B .query-links",=>
      graph_id = jQuery(".add-links").data("graph-id")
      first_node_name = jQuery(".query-all-links-from-A-to-B .first-node-name").val()
      last_node_name = jQuery(".query-all-links-from-A-to-B .last-node-name").val()
      jQuery.ajax
        url: "/graphs/#{graph_id}/query_links",
        method: 'post',
        data: {
          first_node: first_node_name,
          last_node: last_node_name
        }
      .success (msg) =>
        console.log(msg.result)
        jQuery(".query-all-links-from-A-to-B .part-right .result").val(msg.result)

    @$eml.on "click", ".query-links-from-A-with-length",=>
      graph_id = jQuery(".add-links").data("graph-id")
      first_node_name = jQuery(".query-all-links-from-A-to-B .link-from-A-with-length .first-node-name").val()
      length = jQuery(".query-all-links-from-A-to-B .link-from-A-with-length .length").val()
      jQuery.ajax
        url: "/graphs/#{graph_id}/query_links_from_A_with_length",
        method: 'post',
        data: {
          first_node: first_node_name,
          length: length
        }
      .success (msg) =>
        console.log(msg.result)
        jQuery(".query-all-links-from-A-to-B .part-right .result").val(msg.result)

    @$eml.on "click", ".query-links-to-B-with-length",=>
      graph_id = jQuery(".add-links").data("graph-id")
      last_node_name = jQuery(".query-all-links-from-A-to-B .link-to-B-with-length .last-node-name").val()
      length = jQuery(".query-all-links-from-A-to-B .link-to-B-with-length .length").val()
      jQuery.ajax
        url: "/graphs/#{graph_id}/query_links_to_B_with_length",
        method: 'post',
        data: {
          last_node: last_node_name,
          length: length
        }
      .success (msg) =>
        console.log(msg.result)
        jQuery(".query-all-links-from-A-to-B .part-right .result").val(msg.result)

jQuery(document).on "ready page:load", ->
  if jQuery(".page-graph-show").length > 0
    new Graph jQuery(".page-graph-show")