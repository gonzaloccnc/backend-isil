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

@Entity(name = "classroom_view")
@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class ClassroomView {
  @Id
  private String idClassroom;
  private String nrc;
  private String schoolDay;

  //@JsonFormat(pattern = "hh:mm:ss")
  private LocalTime startTime;

  //@JsonFormat(pattern = "hh:mm:ss")
  private LocalTime endTime;

  private String linkMeet;
  private int totalHours;
  private String modality;
  private String campus;
  private String period;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDate startDate;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDate endDate;

  private int maxMembers;
  private String idTeacher;
  private String idCourse;
  private String teacher;
  private String course;
}
