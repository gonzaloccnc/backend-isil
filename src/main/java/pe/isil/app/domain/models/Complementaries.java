package pe.isil.app.domain.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity(name = "complementaries") @Data
@Builder @AllArgsConstructor @NoArgsConstructor
public class Complementaries {

    @Id
    private String idComplementary;
    private String title;
    private String linkFile;
    private LocalDate uploadDate;

    private String idClassroom;
}
