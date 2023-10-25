package pe.isil.app.controllers.Contents;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.isil.app.domain.models.Content;
import pe.isil.app.domain.models.User;
import pe.isil.app.domain.repos.IContentRepo;

@RestController
@RequestMapping("/admin/course/content")
@RequiredArgsConstructor

public class ContentController {

    private final IContentRepo contentService;

    @PostMapping("/Create")
    public Content createContent(@RequestBody Content content) {
        var admin = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        content.setUserCreation(admin.getIdUser());
        return contentService.save(content);
    }

    @PutMapping("/update/{contentId}")
    public Content  updateContent(@RequestBody Content updateContent, @PathVariable("contentId")Integer contentId){
        var admin = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Content contentFromDB = contentService.findById(contentId).orElse(null);
        contentFromDB.setIdContent(contentId);
        contentFromDB.setTitle(updateContent.getTitle());
        contentFromDB.setDescription(updateContent.getDescription());
        contentFromDB.setLinkFile(updateContent.getLinkFile());
        contentFromDB.setNumOrder(updateContent.getNumOrder());
        contentFromDB.setIdCourse(updateContent.getIdCourse());
        contentFromDB.setUserUpdating(admin.getIdUser());
        return contentService.save(contentFromDB);

    }

    @DeleteMapping("/delete/{contentId}")
    public ResponseEntity<Object>deleteContent(@PathVariable("contentId") Integer contentId){
        contentService.deleteById(contentId);
        return ResponseEntity.ok().build();
    }

}
