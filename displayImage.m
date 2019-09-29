function displayImage(image,z_scale)


%check if there is already an image and eventually delete

imageobj = imhandles(gca);
delete(imageobj);

try
    hold on
    himage = imagesc(flipud(image),z_scale);
    hold off
catch err
    
    if (strcmp(err.identifier,'MATLAB:hg:propswch:PropertyError'));
        hold on
        himage= imagesc(flipud(image));
        hold off
        %warning('Inproper range in the imput arguments, replaced by default')        
    else
        rethrow(err);
    end
end

axis image
axis off
uistack(himage,'bottom');
hinf = impixelinfo(himage);
%set(hinf,'BackgroundColor','r')
end