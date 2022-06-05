function [Hp,rows,cols] = get_Patch(sz,p,psz)
    % Returns the indices for a patch centered at pixel p.
   
    w=(psz-1)/2; p=p-1; y=floor(p/sz(1))+1; p=rem(p,sz(1)); x=floor(p)+1;
    rows = max(x-w,1):min(x+w,sz(1));
    cols = (max(y-w,1):min(y+w,sz(2)))';
    Hp = sub2ndx(rows,cols,sz(1));
return;