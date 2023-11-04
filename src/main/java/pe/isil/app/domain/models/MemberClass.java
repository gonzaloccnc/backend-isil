package pe.isil.app.domain.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name = "members_class")
@Data @AllArgsConstructor @NoArgsConstructor @Builder
public class MemberClass {

  @Id
  private String idStudent;
  private String idClassroom;
  private String names;
  private String email;
  private String photo;
}
