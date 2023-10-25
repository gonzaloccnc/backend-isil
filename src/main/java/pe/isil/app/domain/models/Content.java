package pe.isil.app.domain.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity(name = "contents") @Data
@Builder @AllArgsConstructor @NoArgsConstructor
public class Content {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idContent;

    private String title;

    private String description;

    private String linkFile;

    private int numOrder;

    private String idCourse;

    private String userCreation;
    private String userUpdating;

    private LocalDateTime updatedDate;

    @PreUpdate
    private void setDateOfUpdate() {
        this.setUpdatedDate(LocalDateTime.now());
    }
}

