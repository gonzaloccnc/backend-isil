package pe.isil.app.domain.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
@Entity(name = "user_profile")
public class UserProfile {

  @Id
  private String idUser;
  private String firstname;
  private String surnames;
  private LocalDate birthday;
  private String address;
  private String docId;
  private String email;
  private String phone;
  private String photo;
  private String career;
}
