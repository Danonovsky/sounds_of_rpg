import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/entities/sound.dart';
import 'package:sounds_of_rpg/services/storage_service.dart';
import 'package:sounds_of_rpg/widgets/add_sound_dialog.dart';
import 'package:sounds_of_rpg/widgets/sound_tile.dart';

class MainSection extends StatefulWidget {
  MainSection({Key? key, required this.sounds, required this.selectedCategory})
      : super(key: key);

  late List<Sound> sounds;
  late Category? selectedCategory;

  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  final StorageService _storageService = StorageService();

  Future showAddDialog() async {
    var sound = await showDialog<SoundDto>(
      context: context,
      builder: (context) => AddSoundDialog(
        selectedCategory: widget.selectedCategory!,
      ),
    );
    if (sound == null) return;
    await _storageService.saveSoundFile(sound);
    setState(() {
      widget.sounds.add(Sound(
        categoryId: sound.categoryId,
        iconCode: sound.iconCode,
        iconFontFamily: sound.iconFontFamily,
        id: sound.id,
        name: sound.name,
        extension: '',
      ));
    });
    await _storageService.saveSounds(widget.sounds);
  }

  void deleteSound(Sound sound) async {
    setState(() {
      widget.sounds.remove(sound);
    });
    await _storageService.removeSound(sound);
    await _storageService.saveSounds(widget.sounds);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            Visibility(
              visible: widget.selectedCategory != null,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    onPressed: () async {
                      await showAddDialog();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                children: widget.sounds
                    .where(
                      (element) {
                        if (widget.selectedCategory == null) return true;
                        return element.categoryId ==
                            widget.selectedCategory!.id;
                      },
                    )
                    .map(
                      (e) => SoundTile(
                        sound: e,
                        onDelete: () => deleteSound(e),
                        playSingle: () {},
                        playLoop: () {},
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
