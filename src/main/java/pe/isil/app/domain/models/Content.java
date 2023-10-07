package pe.isil.app.domain.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name = "contents")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor

public class Content {

    @Id
    private int id_content;

    private String title;

    private String description;

    private String linkFile;

    private int numOrder;

    //@JoinColumn(name = "idCourse", referencedColumnName = "id_course")
    //private Course course;

    private String idCourse;
}

