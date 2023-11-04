package pe.isil.app.domain.dtos;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.isil.app.domain.models.ClassGroupsStudents;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class GroupsDto {

    //private String groupName;
    //private List<ClassGroupsStudents> students ;

    private String idClassroom;
    private String idStudents;
    private Integer idGroup;


}
