package pe.isil.app.controllers.complementaries;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.isil.app.domain.dtos.ErrorDto;
import pe.isil.app.domain.models.Complementaries;

import pe.isil.app.domain.repos.IComplementariesRepo;

import java.rmi.server.UID;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;


@RestController
@RequestMapping("/user/course/complementaries")
@RequiredArgsConstructor
public class ComplementariesController {

    private final IComplementariesRepo complementariesService;

    @PostMapping("/create")
    public Complementaries createComplementaries(@RequestBody Complementaries complementaries) {
        complementaries.setUploadDate(LocalDate.now());
        complementaries.setIdComplementary(UUID.randomUUID().toString());
        return complementariesService.save(complementaries);
    }

    @PutMapping("/update/{id_complementary}")
    public Complementaries updateComplementaries(@RequestBody Complementaries updateComplementaries, @PathVariable("id_complementary")String id_complementary){
    Complementaries complementariesFromDB = complementariesService.findById(id_complementary).orElse(null);

        updateComplementaries.setIdComplementary(id_complementary);
        updateComplementaries.setTitle(updateComplementaries.getTitle());
        updateComplementaries.setLinkFile(updateComplementaries.getLinkFile());
        updateComplementaries.setIdClassroom(updateComplementaries.getIdClassroom());

        updateComplementaries.setUploadDate(complementariesFromDB.getUploadDate());

        return complementariesService.save(updateComplementaries);
    }

    @GetMapping("/{idClass}")
    public List<Complementaries> getComplementaries(@PathVariable String idClass) {
        return complementariesService.findAllByIdClassroom(idClass);
    }
}
