function [indices,a] = index_of_electrodes(vector_string_electrodes,header_down)

    header_down_label = header_down.Label;
    indices = []
    
    for i=1:length(vector_string_electrodes)
        for header_index=1:length(header_down_label)
            
            electrode_name = vector_string_electrodes(i)
            header_electrode_name = header_down_label(header_index)
            
            if(strcmp(electrode_name{1},header_electrode_name{1}))
                indices = horzcat(indices,header_index);
            end
        end
    end
end