function N = sub2ndx(rows,cols,nTotalRows)
    %Converts the (rows,cols) to indices
    int_range
    x = rows(ones(length(cols),1),:);
    y = cols(:,ones(1,length(rows)));
    N = x+(y-1)*nTotalRows;
return;

