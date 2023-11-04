package pe.isil.app.domain.models;


import jakarta.persistence.*;
import lombok.*;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.Serializable;

@Entity(name = "class_groups_students")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ClassGroupsStudents {

    @EmbeddedId
    private KeyClass keyClass;
    private Integer idGroup;




}
