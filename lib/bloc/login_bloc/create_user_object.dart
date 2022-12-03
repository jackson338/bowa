import 'dart:convert';

import 'package:bowa/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> createUserObject(List accountInfo, bool autoLogin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  User newUser = const User.empty();
  if (prefs.getString('${accountInfo[1]} user') != null) {
    final json = jsonDecode(prefs.getString('${accountInfo[1]} user')!);
    newUser = User.fromJson(json);
  }

 
  return newUser;

   // final User user = User(
  //   username: accountInfo[0],
  //   authorName: accountInfo[1],
  //   email: accountInfo[2],
  //   password: accountInfo[3],
  //   id: accountInfo[4],
  //   autoLogin: autoLogin,
  //   library: library,
  // );

  // List<String>? bookIds;
  // if (prefs.getStringList('${accountInfo[4]} title ids list') != null) {
  //   bookIds = prefs.getStringList('${accountInfo[4]} title ids list')!;

  //   library = List.generate(bookIds.length, (index) {
  //     List<int> drafts = [];
  //     SideNotes? sideNotes;
  //     final draftStrings = prefs.getStringList('${bookIds![index]} drafts');
  //     if (draftStrings != null) {
  //       for (final draftString in draftStrings) {
  //         drafts.add(int.parse(draftString));
  //       }
  //     }
  //     final chapterTitles = List.generate(
  //         drafts.length,
  //         (draftIndex) => prefs
  //             .getStringList('${bookIds![index]} ${drafts[draftIndex]} chapterNames'));
  //     final chapterTexts = List.generate(
  //         drafts.length,
  //         (draftIndex) => prefs
  //             .getStringList('${bookIds![index]} ${drafts[draftIndex]} chapterText'));
  //     final jsonChapterTexts = [];
  //     for (int draftIndex = 0; draftIndex < drafts.length; draftIndex++) {
  //       if (prefs.getStringList('${bookIds[index]} ${drafts[draftIndex]} jsonChapters') !=
  //           null) {
  //         for (String chapter in prefs
  //             .getStringList('${bookIds[index]} ${drafts[draftIndex]} jsonChapters')!) {
  //           var chapterJson = jsonDecode(chapter);
  //           jsonChapterTexts.add(chapterJson);
  //         }
  //       }
  //     }

  //     final List<int> wordGoals = [];
  //     for (int draftIndex = 0; draftIndex < drafts.length; draftIndex++) {
  //       if (prefs.getString('${bookIds[index]} ${drafts[draftIndex]} word goal') !=
  //           null) {
  //         wordGoals.add(int.parse(
  //             prefs.getString('${bookIds[index]} ${drafts[draftIndex]} word goal')!));
  //       } else {
  //         wordGoals.add(50000);
  //       }
  //     }

  //     final chapters = List.generate(
  //         drafts.length,
  //         (draftIndex) =>
  //             prefs.getStringList('${bookIds![index]} ${drafts[draftIndex]} chapters'));

  //     if (prefs.getStringList('${bookIds[index]} note keys') != null &&
  //         prefs.getStringList('${bookIds[index]} note vals') != null) {
  //       Map<String, String> notes = {};
  //       List<String> keys = prefs.getStringList('${bookIds[index]} note keys')!;
  //       List<String> vals = prefs.getStringList('${bookIds[index]} note vals')!;
  //       for (int noteIndex = 0; noteIndex < keys.length; noteIndex++) {
  //         notes.addAll({keys[noteIndex]: vals[noteIndex]});
  //       }
  //       int outlines = 0;
  //       int characters = 0;
  //       int note = 0;
  //       if (prefs.getInt('${bookIds[index]} outlines') != null) {
  //         outlines = prefs.getInt('${bookIds[index]} outlines')!;
  //       }
  //       if (prefs.getInt('${bookIds[index]} characters') != null) {
  //         characters = prefs.getInt('${bookIds[index]} characters')!;
  //       }
  //       if (prefs.getInt('${bookIds[index]} note') != null) {
  //         note = prefs.getInt('${bookIds[index]} note')!;
  //       }
  //       sideNotes = SideNotes(
  //           notes: notes, outlines: outlines, characters: characters, note: note);
  //     }
  //     return Book(
  //       id: bookIds[index],
  //       title: prefs.getString('${bookIds[index]} title')!,
  //       chapterTitles: chapterTitles,
  //       chapterTexts: chapterTexts,
  //       chapters: chapters,
  //       jsonChapterTexts: jsonChapterTexts,
  //       drafts: drafts,
  //       selectedDraft: prefs.getInt('${bookIds[index]} selected draft') ?? 0,
  //       wordGoals: wordGoals,
  //       sideNotes: sideNotes,
  //     );
  //   });
  // }
}
