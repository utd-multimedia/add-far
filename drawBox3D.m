function drawBox3D(corners,face_idx)
% drawBox3D to draw the 3B bounding box
% args:
% corners 8 corners
% face_idx index for 3D bounding box faces

  % set styles for occlusion and truncation
  occ_col    = {'g','y','r','w'};
  trun_style = {'-','--'};

  
  % draw projected 3D bounding boxes
  if ~isempty(corners)
    for f=1:4
      line([corners(1,face_idx(f,:)),corners(1,face_idx(f,1))],...
           [corners(2,face_idx(f,:)),corners(2,face_idx(f,1))],...
           [corners(3,face_idx(f,:)),corners(3,face_idx(f,1))],...
           'color',occ_col{3},...
           'LineWidth',1,'LineStyle',trun_style{1});

    end
  end
  

end
