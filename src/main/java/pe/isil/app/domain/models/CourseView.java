package pe.isil.app.domain.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name = "course_view") @Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CourseView {

    @Id
    private String idCourse;

    private String courseName;
    private int credits;
    private String description;
    private String syllabus;
    private String idStudent;

}

