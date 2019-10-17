// todo: make switcher for Flutter and variable in CatchMeApp
// todo: remove Strings.dart

abstract class Language {
    get appTitle => "CatchMe";
    get dialogTitle => "Dialogs";
    get settingsTitle => "Settings";
    get allUsersTitle => "All Users";
    get lastSeen => "last seen ";
    get recently => "last seen recently";
    get online => "online";
    get deleteThisChatForever => "Delete this chat forever";
    get typeYourMessageHere => "Type message here...";
    get youDoNotHaveAnyMessagesYet => "You don't have any messages.";
    get writeFirst => "Write first😏";
    get block => " Block";
    get unblock => " Unblock";
    get noMessagesYet => "No messages yet...";
    get photoTitle => "Photo";
    get signOutButton => "Sign out";
    get changeNameHint => "Name";
    get changeEmailHint => "Email";
    get welcomeToCatchMe => "Welcome to CatchMe.";
    get signInWithGoogle => "Sign in with Google";
    get lastMessageIsPicture => "🏞 Picture";


    String photoUploadingIndicator(int quantity) {
        if(quantity == 0) return 'Done 👍';
        if(quantity == 1) return 'Sending your photo';
        return 'Sending $quantity photos';
    }
    // todo: weekdays shortend
}

class RuLang extends Language {
    get dialogTitle => "Диалоги";
    get settingsTitle => "Настройки";
    get allUsersTitle => "Кому написать?";
    get lastSeen => "был(-а) в сети ";
    get recently => "был(-а) в сети недавно";
    get online => "в сети";
    get deleteThisChatForever => "Удалить этот чат навсегда";
    get typeYourMessageHere => "Напишите сообщение...";
    get youDoNotHaveAnyMessagesYet => "У вас пока нет сообщений.";
    get writeFirst => "Напишите первыми😏";
    get lastMessageIsPicture => "🏞 Изображение";
    get block => ' Заблокировать';
    get unblock => 'Разблокировать';
    get noMessagesYet => 'Сообщений пока нет';
    get photoTitle => 'Фотография';
    get signOutButton => 'Выйти';
    get changeNameHint => 'Имя';
    get changeEmailHint => 'Электронная почта';
    get welcomeToCatchMe => 'Добро пожаловать в CatchMe.';
    get signInWithGoogle => 'Войти с помощью Google';
    get appTitle => 'CatchMe';

    String photoUploadingIndicator(int quantity) {
        if(quantity == 0) return 'Готово 👍';
        if(quantity == 1) return 'Отправляю фотографию';
        if(quantity % 10 < 5) return 'Отправляю $quantity фотографии';
        return 'Отправляю $quantity фотографий';
    }

}

class EnLang extends Language {}