package pe.isil.app.domain.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class ClassroomDto {
  private String idClassroom;
  private String nrc;
  private String schoolDay;
  private LocalTime startTime;
  private LocalTime endTime;
  private String linkMeet;
  private int totalHours;
  private String modality;
  private String campus;
  private String period;
  private LocalDate startDate;
  private LocalDate endDate;
  private int maxMembers;
  private String idTeacher;
  private String idCourse;
}
