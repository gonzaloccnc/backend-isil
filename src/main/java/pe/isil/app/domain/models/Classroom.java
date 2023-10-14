package pe.isil.app.domain.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.isil.app.domain.dtos.ClassroomDto;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity(name = "classrooms")
@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class Classroom {
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
  private int modality;
  private String campus;
  private String period;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDate startDate;

  @JsonFormat(pattern = "yyyy-MM-dd")
  private LocalDate endDate;

  private int maxMembers;
  private String idTeacher;
  private String idCourse;

  public ClassroomDto toDto() {

    var dto = new ClassroomDto();

    switch (modality) {
      case 1 -> {
        dto.setModality("VIRTUAL");
      }

      case 2 -> {
        dto.setModality("REMOTO");
      }

      case 3 -> {
        dto.setModality("SEMIREMOTO");
      }

      default -> {
        dto.setModality("PRESENCIAL");
      }
    }

    return ClassroomDto
        .builder()
        .idClassroom(idClassroom)
        .nrc(nrc)
        .schoolDay(schoolDay)
        .startTime(startTime)
        .endTime(endTime)
        .linkMeet(linkMeet)
        .totalHours(totalHours)
        .modality(dto.getModality())
        .campus(campus)
        .period(period)
        .startDate(startDate)
        .endDate(endDate)
        .maxMembers(maxMembers)
        .idTeacher(idTeacher)
        .idCourse(idCourse).build();
  }
}
