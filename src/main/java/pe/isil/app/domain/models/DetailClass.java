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

@Entity(name = "class_details_view")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DetailClass {
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

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate startDate;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate endDate;
    private String idTeacher;
    private String idCourse;
    private String courseName;
    private String description;
    private String idStudent;
    private String teacherFirstname;
    private String teacherSurnames;
    private String studentFirstname;
    private String studentSurnames;


}
