package pe.isil.app.domain.models;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name = "groups_class")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class GroupsClass {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idGroup;

    private String groupName;



}
