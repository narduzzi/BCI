function [indices] = index_of_electrodes(vector_string_electrodes,header_down_label)

    indices = []
    for i=1:length(vector_string_electrodes)
        for header_index=1:length(header_down_label)
            electrode_name = vector_string_electrodes(i);
            header_electrode_name = header_down_label(header_index);
            
            if(electrode_name==header_electrode_name)
                indices = horzcat(indices,header_index)
            end
        end
    end
end