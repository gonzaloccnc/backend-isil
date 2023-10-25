package pe.isil.app.domain.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.PreUpdate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity(name = "courses") @Data
@Builder @AllArgsConstructor @NoArgsConstructor
public class Course {
  @Id
  private String idCourse;

  private String courseName;
  private int credits;
  private String description;
  private String syllabus;

  private String userCreation;
  private String userUpdating;

  private LocalDateTime updatedDate;

  @PreUpdate
  private void setDateOfUpdate() {
    this.setUpdatedDate(LocalDateTime.now());
  }
}
