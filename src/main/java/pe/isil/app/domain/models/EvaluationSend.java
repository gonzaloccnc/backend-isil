package pe.isil.app.domain.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity(name = "evaluations_send")
@AllArgsConstructor @NoArgsConstructor
@Data @Builder
public class EvaluationSend {

  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int idSend;

  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  private LocalDateTime sendDate;

  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  private LocalDateTime sendUpdateDate;

  private String userSend;
  private String userUpdate;
  private int idEvaluation;

  private String linkFile;
  private Integer idGroup;

  @PrePersist
  private void setSendDate() {
    this.sendDate = LocalDateTime.now();
  }

  @PreUpdate
  public void updateSendDate() {
    this.sendUpdateDate = LocalDateTime.now();
  }
}
