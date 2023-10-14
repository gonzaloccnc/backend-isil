package pe.isil.app.controllers.Contents;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.isil.app.domain.models.Content;
import pe.isil.app.domain.repos.IContentRepo;

import java.util.UUID;

@RestController
@RequestMapping("/admin/course/content")
@RequiredArgsConstructor

public class ContentController {

    private final IContentRepo contentService;


    @PostMapping("/Create")
    public Content createContent(@RequestBody Content content) {
        return  contentService.save(content);
        
    }

    @PutMapping("/update/{contentId}")
    public Content  updateContent(@RequestBody Content updateContent, @PathVariable("contentId")Integer contentId){
        Content contentFromDB = contentService.findById(contentId).orElse(null);
        contentFromDB.setId_content(contentId);
        contentFromDB.setTitle(updateContent.getTitle());
        contentFromDB.setDescription(updateContent.getDescription());
        contentFromDB.setLinkFile(updateContent.getLinkFile());
        contentFromDB.setNumOrder(updateContent.getNumOrder());
        contentFromDB.setIdCourse(updateContent.getIdCourse());
        return contentService.save(contentFromDB);

    }

    @DeleteMapping("/delete/{contentId}")
    public ResponseEntity<Object>deleteContent(@PathVariable("contentId") Integer contentId){
        contentService.deleteById(contentId);
        return ResponseEntity.ok().build();
    }

}
