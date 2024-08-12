%% code to analyse morphology of Kaggle data
%%filepath_ascii='' %%filename for amira output
%outputname=baseline;
%filepath_output=fullfile('F:\Dropbox (UCL)\UCL Dropbox\Bio\Kaggle_paper\Figures\Skeletons_winning\outputs_data',output_name)

[edge_network,vert_network,point_network,edge, point,vertex]=ultimate_amira_read(filepath_ascii) %% read networks

G=graph(edge_network.EdgeConnectivity_EDGE{1}(:,1)+1,edge_network.EdgeConnectivity_EDGE{1}(:,2)+1);
subgraph_no=length(unique(conncomp(G)));


edge_ids = unique(edge_network.EdgeConnectivity_EDGE{:});
counts = histcounts(edge_network.EdgeConnectivity_EDGE{:}, edge_ids); %this is the co-ordination number
idx = find(counts >= 3);  % find the branching point nodes
%%assert(length(idx)==node_stats{4},'wrong numbner of nodes')
branching_nodes=edge_ids(idx);
no_branched_nodes=length(idx);
no_terminal_nodes=(vertex-no_branched_nodes);

counter_branch=0;

for j=1:length(branching_nodes)
    counter_branch=counter_branch+1;
    centre_node=branching_nodes(j);
branch_segs=find(edge_network.EdgeConnectivity_EDGE{:}==centre_node);
for i=1:length(branch_segs)
    if branch_segs(i)>size(edge_network.EdgeConnectivity_EDGE{:},1)  %% make the row numbers match the columns
        branch_segs(i)=branch_segs(i)-size(edge_network.EdgeConnectivity_EDGE{:},1);
    end
end


parent_coords=vert_network.VertexCoordinates_VERTEX{:}(centre_node+1,:);
all_nodes=unique(edge_network.EdgeConnectivity_EDGE{:}(branch_segs,:));

child_nodes=all_nodes(find(all_nodes~=centre_node));
child_coords=vert_network.VertexCoordinates_VERTEX{:}(child_nodes+1,:);

if length(all_nodes)==4
 %find vector between parents and children
    vec1 = parent_coords  - child_coords(1,:);
    vec2 = parent_coords - child_coords(2,:);
    vec3 = parent_coords - child_coords(3,:);

    branch_angle(counter_branch,:)=[branching_ang(vec1,vec2),branching_ang(vec1,vec3),branching_ang(vec2,vec3)];
else
    branch_angle(counter_branch,:)=[NaN,NaN,NaN];
end

end
 branch_angle=reshape(branch_angle,[1,no_branched_nodes*3]);
 branch_angle=[branch_angle]';
 branch_angle=branch_angle(~isnan(branch_angle));

 % Save outputs not working
%writetable(edge_network,filepath_output);

graphinfo=table(no_branched_nodes,no_terminal_nodes,subgraph_no,vertex,edge);