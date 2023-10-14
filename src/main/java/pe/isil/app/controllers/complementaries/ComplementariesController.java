package pe.isil.app.controllers.complementaries;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.isil.app.domain.dtos.ErrorDto;
import pe.isil.app.domain.models.Complementaries;

import pe.isil.app.domain.repos.IComplementariesRepo;

import java.rmi.server.UID;
import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;


@RestController
@RequestMapping("/user/course/complementaries")
@RequiredArgsConstructor
public class ComplementariesController {

    private final IComplementariesRepo complementariesService;

    @PostMapping("/create")
    public Complementaries createComplementaries(@RequestBody Complementaries complementaries) {
        complementaries.setUpload_date(LocalDate.now());
        complementaries.setId_complementary(UUID.randomUUID().toString());
        return complementariesService.save(complementaries);
    }

    @PutMapping("/update/{id_complementary}")
    public Complementaries updateComplementaries(@RequestBody Complementaries updateComplementaries, @PathVariable("id_complementary")String id_complementary){
    Complementaries complementariesFromDB = complementariesService.findById(id_complementary).orElse(null);

        updateComplementaries.setId_complementary(id_complementary);
        updateComplementaries.setTitle(updateComplementaries.getTitle());
        updateComplementaries.setLink_file(updateComplementaries.getLink_file());
        updateComplementaries.setId_classroom(updateComplementaries.getId_classroom());

        updateComplementaries.setUpload_date(complementariesFromDB.getUpload_date());

        return complementariesService.save(updateComplementaries);


    }



}
