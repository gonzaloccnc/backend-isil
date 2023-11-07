package pe.isil.app.domain.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity(name = "evaluations")
@AllArgsConstructor @NoArgsConstructor
@Data @Builder
public class Evaluation {

  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int idEvaluation;

  private String type;

  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  private LocalDateTime startDate;
  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  private LocalDateTime endDate;
  private String linkFile;
  private byte isVisible;
  private byte itsGroup;
  private String idClassroom;

}
