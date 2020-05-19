function idx = jaccard(log1,log2)
%calculate the Jaccard index


inter_image = log1 & log2;
union_image = log1 | log2;
idx = sum(sum(inter_image))./sum(sum(union_image));


end

