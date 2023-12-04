package pe.isil.app.domain.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Data @Entity
@Builder
@AllArgsConstructor @NoArgsConstructor
public class DashboardTodayClasses {

  @Id
  private String IdClassroom;

  private String nrc;

  @JsonFormat(pattern = "HH:mm")
  private LocalTime startTime;

  @JsonFormat(pattern = "HH:mm")
  private LocalTime endTime;

  private String linkMeet;
  private String schoolDay;
  private Short totalHours;
  private Short modality;
  private String campus;
  private String period;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDate startDate;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDate endDate;

  private Integer maxMembers;
  private String idTeacher;
  private String idCourse;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDate creationDate;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDate updatedDate;

  private String userCreation;
  private String userUpdating;
  private String idStudent;
}
