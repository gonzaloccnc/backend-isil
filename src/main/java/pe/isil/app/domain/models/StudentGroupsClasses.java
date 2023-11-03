package pe.isil.app.domain.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name = "student_groups_classes")
@Data @AllArgsConstructor @NoArgsConstructor @Builder
public class StudentGroupsClasses {

  @Id
  private String idStudent;

  private String idClassroom;

  private int idGroup;
  private String groupName;
  private String names;
  private String photo;
  private String email;
}
