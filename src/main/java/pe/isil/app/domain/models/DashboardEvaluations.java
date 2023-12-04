package pe.isil.app.domain.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data @Entity
@Builder
@AllArgsConstructor @NoArgsConstructor
public class DashboardEvaluations {

  @Id
  private Integer idEvaluation;

  private String type;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDateTime startDate;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDateTime endDate;

  private String linkFile;
  private Short isVisible;
  private Short itsGroup;
  private String idClassroom;
  private String idStudent;
}
