﻿&НаКлиенте
Процедура ФиоПриИзменении(Элемент)
	Объект.Фамилия = ?(Элемент.Имя = "Фамилия", ОчиститьПоМаскеФИО(Объект.Фамилия), Объект.Фамилия);
	Объект.Имя = ?(Элемент.Имя = "Имя", ОчиститьПоМаскеФИО(Объект.Имя), Объект.Имя);
	Объект.Отчество = ?(Элемент.Имя = "Отчество", ОчиститьПоМаскеФИО(Объект.Отчество), Объект.Отчество);

	ПредЗначение = Объект.Наименование;
	Попытка
		Объект.Наименование = СоставитьФИО(Объект.Фамилия, Объект.Имя, Объект.Отчество);
	Исключение
		ПоказатьПредупреждение( , , ИнформацияОбОшибке());
		Элемент.ТекстРедактирования = "";
	КонецПопытки;
КонецПроцедуры

&НаСервере
Функция ОчиститьПоМаскеФИО(Строка)
	результатПоиска = СтрНайтиПоРегулярномуВыражению(Строка, "[а-яА-ЯЁё\-]+");
	Если результатПоиска.НачальнаяПозиция = 0 Тогда
		Возврат "";
	КонецЕсли;

	Строка = СтрЗаменитьПоРегулярномуВыражению(результатПоиска.Значение, "-{2}", "-");
	результатПоиска = СтрНайтиПоРегулярномуВыражению(Строка, "^([а-яА-ЯЁё]+)((?:\-[а-яА-ЯЁё]+)?)$");

	Если результатПоиска.НачальнаяПозиция > 0 Тогда
		группыПоиска = результатПоиска.ПолучитьГруппы();
		Если ЗначениеЗаполнено(группыПоиска) И группыПоиска[0].НачальнаяПозиция > 0 И группыПоиска.Количество() >= 1 Тогда
			результат = группыПоиска[0].Значение;
			результат = ВРег(Лев(результат, 1)) + НРег(Сред(результат, 2));

			группыПоиска.Удалить(0);
			Для Каждого группа Из группыПоиска Цикл
				Если группа.НачальнаяПозиция > 0 Тогда
					результат = результат + ВРег(Лев(группа.Значение, 2)) + НРег(Сред(группа.Значение, 3));
				КонецЕсли;
			КонецЦикла;

			Возврат результат;
		КонецЕсли;
	Иначе
		ВызватьИсключение("Ошибка. Неверный формат ввода.");
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция СоставитьФИО(Фамилия, Имя, Отчество)
	Возврат СокрЛП(СтрШаблон("%1 %2 %3", Фамилия, Имя, Отчество));
КонецФункции
