insert into public.goals (
  goal_key,
  title_uk,
  title_en,
  description_uk,
  description_en,
  icon_key,
  sort_order
)
values
  ('hydration_support', 'Підтримка гідратації', 'Hydration support', 'М’який акцент на воді, aloe-first звичках та щоденному ритмі.', 'A gentle focus on hydration, aloe-first habits, and a steady daily rhythm.', 'water_drop', 1),
  ('daily_wellness_routine', 'Щоденний wellness-ритм', 'Daily wellness routine', 'Простий план дня без перевантаження та складних правил.', 'A simple daily rhythm without overload or rigid rules.', 'sunny', 2),
  ('energy_support', 'Підтримка енергії', 'Energy support', 'Ритм дня, відновлення та більш стабільна бадьорість.', 'A structured day, recovery, and steadier energy.', 'bolt', 3),
  ('beauty_skin_support', 'Краса та wellness шкіри', 'Beauty and skin wellness', 'Hydration, сон та aloe-inspired догляд як частина цілісної рутини.', 'Hydration, sleep, and aloe-inspired care as part of a balanced routine.', 'spa', 4),
  ('healthy_routine_support', 'Підтримка здорової рутини', 'Healthy routine support', 'Комфортний темп, базові звички та простий щоденний порядок.', 'A comfortable pace, core habits, and a simple daily structure.', 'check_circle', 5),
  ('consistency_self_care', 'Послідовність і self-care', 'Consistency and self-care', 'М’яка дисципліна, відновлення та турбота про себе без жорсткого тиску.', 'Gentle consistency, recovery, and self-care without harsh pressure.', 'self_improvement', 6)
on conflict (goal_key) do update
set
  title_uk = excluded.title_uk,
  title_en = excluded.title_en,
  description_uk = excluded.description_uk,
  description_en = excluded.description_en,
  icon_key = excluded.icon_key,
  sort_order = excluded.sort_order;

insert into public.product_categories (
  id,
  title_uk,
  title_en,
  subtitle_uk,
  subtitle_en,
  icon_key,
  sort_order
)
values
  ('aloe_drinks', 'Aloe напої та гелі', 'Aloe drinks and gels', 'Щоденна база для водного ритму та wellness-звичок.', 'A daily base for hydration rhythm and wellness habits.', 'water_drop', 1),
  ('nutrition', 'Харчова підтримка', 'Nutrition', 'Шейки, протеїн і щоденні форматні рішення.', 'Shakes, protein, and daily structured nutrition support.', 'nutrition', 2),
  ('bee_products', 'Bee-продукти', 'Bee products', 'Комплекси з пилком, прополісом та honey-inspired формулами.', 'Formulas inspired by bee products, pollen, and propolis.', 'hive', 3),
  ('skincare', 'Skincare', 'Skincare', 'М’який догляд, комфорт шкіри та aloe-first текстури.', 'Gentle care, skin comfort, and aloe-first textures.', 'spa', 4),
  ('personal_care', 'Особистий догляд', 'Personal care', 'Щоденна гігієна та ритуали турботи про себе.', 'Daily hygiene and self-care rituals.', 'self_improvement', 5),
  ('combo_packs', 'Комбо-набори', 'Combo packs', 'Готові поєднання для старту 7/14/21-денних програм.', 'Ready-made sets for 7, 14, and 21-day plans.', 'inventory_2', 6)
on conflict (id) do update
set
  title_uk = excluded.title_uk,
  title_en = excluded.title_en,
  subtitle_uk = excluded.subtitle_uk,
  subtitle_en = excluded.subtitle_en,
  icon_key = excluded.icon_key,
  sort_order = excluded.sort_order;

insert into public.product_tags (slug, label_uk)
values
  ('hydration', 'Гідратація'),
  ('aloe', 'Aloe'),
  ('daily-routine', 'Щоденний ритм'),
  ('nutrition', 'Харчування'),
  ('energy', 'Енергія'),
  ('focus', 'Фокус'),
  ('healthy-routine', 'Здорова рутина'),
  ('balance', 'Баланс'),
  ('beauty', 'Краса'),
  ('skin', 'Шкіра'),
  ('bee', 'Bee-продукти'),
  ('combo', 'Набір'),
  ('self-care', 'Self-care')
on conflict (slug) do update
set label_uk = excluded.label_uk;

insert into public.products (
  id,
  category_id,
  title_uk,
  title_en,
  short_description_uk,
  short_description_en,
  usage_notes_uk,
  usage_notes_en,
  caution_notes_uk,
  caution_notes_en,
  image_token,
  external_product_url,
  highlight_uk,
  highlight_en,
  is_featured,
  wellness_tags
)
values
  ('aloe-gel-classic', 'aloe_drinks', 'Aloe Gel Classic', 'Aloe Gel Classic', 'Класичний aloe-first напій для щоденного wellness-ритму та гідратаційної рутини.', 'A classic aloe-first drink for a daily wellness rhythm and hydration routine.', 'Використовуйте як частину ранкового або денного ритуалу разом із достатнім споживанням води.', 'Use as part of a morning or daytime ritual alongside adequate hydration.', 'Не є медичним продуктом. Якщо ви маєте індивідуальні обмеження у харчуванні, перевіряйте склад та порадьтеся з фахівцем.', 'Not a medical product. If you have dietary restrictions, review the ingredients and consult a qualified professional when needed.', 'aloe', 'https://www.foreverliving.com/', 'База для щоденного aloe-ритму', 'A daily aloe routine base', true, '{"hydration","aloe","daily-routine"}'),
  ('aloe-berry-balance', 'aloe_drinks', 'Aloe Berry Balance', 'Aloe Berry Balance', 'Aloe-напій із ягідним смаком для тих, хто хоче підтримати питний ритм більш м’яко.', 'A berry-flavored aloe drink for a softer hydration rhythm.', 'Підійде для ротації смаків у 14- чи 21-денному плані без перевантаження рутини.', 'Good for rotating flavors within a 14 or 21-day routine without adding complexity.', 'Завжди звіряйте індивідуальну переносимість інгредієнтів. Це загальна wellness-підтримка.', 'Always check ingredient tolerance. This is general wellness support only.', 'berry', 'https://www.foreverliving.com/', 'Смаковий варіант для гідратаційного плану', 'A flavor-forward hydration option', false, '{"hydration","beauty","aloe"}'),
  ('daily-shake-vanilla', 'nutrition', 'Daily Shake Vanilla', 'Daily Shake Vanilla', 'Поживний shake для структурованого початку дня або контрольованого перекусу.', 'A nourishing shake for a structured morning or a balanced snack.', 'Найкраще працює як частина збалансованого меню та стабільного режиму харчування.', 'Works best as part of a balanced menu and a steady eating rhythm.', 'Не замінює повноцінний індивідуальний план харчування та не призначений для лікувальних цілей.', 'Not a substitute for an individualized nutrition plan and not intended for treatment purposes.', 'shake', 'https://www.foreverliving.com/', 'Комфортний формат для ранкового старту', 'An easy format for a smooth start', true, '{"nutrition","energy","healthy-routine"}'),
  ('fiber-routine-mix', 'nutrition', 'Fiber Routine Mix', 'Fiber Routine Mix', 'Формат для доповнення щоденної рутини, коли хочеться більше структури в меню.', 'A daily support format for users who want more structure in their eating routine.', 'Поєднуйте з водою та базовими харчовими звичками, а не як ізольоване рішення.', 'Use alongside hydration and core nutrition habits rather than as a standalone solution.', 'Підходить не всім раціонам. Перед використанням перевірте склад і спосіб споживання.', 'Not suitable for every diet. Review ingredients and usage instructions before use.', 'fiber', 'https://www.foreverliving.com/', 'Зручний супровід для щоденного меню', 'A practical companion for a steady routine', false, '{"balance","healthy-routine","daily-routine"}'),
  ('bee-pollen-daily', 'bee_products', 'Bee Pollen Daily', 'Bee Pollen Daily', 'Bee-комплекс для тих, хто хоче урізноманітнити свій щоденний wellness-набір.', 'A bee-based product for users who want more variety in a daily wellness routine.', 'Додавайте поступово, відстежуючи комфорт використання та власний режим.', 'Introduce gradually while monitoring comfort and fit within your personal routine.', 'Містить компоненти бджільництва. У разі чутливості або алергій потрібна додаткова обережність.', 'Contains bee-derived ingredients. Use additional caution if you have sensitivities or allergies.', 'bee', 'https://www.foreverliving.com/', 'Bee-support для структурованого дня', 'Bee-inspired support for a structured day', false, '{"energy","nutrition","focus"}'),
  ('propolis-soft-support', 'bee_products', 'Propolis Soft Support', 'Propolis Soft Support', 'Делікатний bee-продукт для побудови стабільної особистої рутини.', 'A gentle bee-based product for building a steadier personal routine.', 'Використовуйте лише в межах загального wellness-підходу та без очікування медичних ефектів.', 'Use only within a general wellness routine and without expecting medical effects.', 'Не використовуйте без перевірки складу, якщо маєте індивідуальні реакції на продукти бджільництва.', 'Review the ingredients carefully if you react to bee products.', 'propolis', 'https://www.foreverliving.com/', 'М’яка bee-підтримка для щоденного ритуалу', 'Gentle bee-inspired routine support', false, '{"daily-routine","balance","bee"}'),
  ('aloe-hydra-cream', 'skincare', 'Aloe Hydra Cream', 'Aloe Hydra Cream', 'Крем для комфортного щоденного догляду з акцентом на aloe-inspired текстуру.', 'A cream for comfortable daily care with an aloe-inspired texture.', 'Поєднуйте з достатнім сном, водою та базовою рутиною догляду.', 'Pair with adequate sleep, hydration, and a steady care routine.', 'Для зовнішнього використання. Перед регулярним застосуванням перевірте індивідуальну чутливість.', 'For external use only. Check individual sensitivity before regular use.', 'cream', 'https://www.foreverliving.com/', 'Щоденний догляд для beauty-ритуалу', 'Daily care for a beauty routine', true, '{"beauty","skin","hydration"}'),
  ('aloe-soothing-gelly', 'skincare', 'Aloe Soothing Gelly', 'Aloe Soothing Gelly', 'Легка aloe-формула для домашнього self-care ритуалу та комфорту шкіри.', 'A light aloe formula for home self-care and skin comfort.', 'Підходить як частина базового догляду, коли потрібне відчуття м’якості та свіжості.', 'Suitable as part of basic care when you want a softer, fresher feel.', 'Це не лікувальний засіб. Не використовуйте на подразнених ділянках без професійної поради.', 'This is not a treatment product. Do not use on irritated areas without professional guidance.', 'gelly', 'https://www.foreverliving.com/', 'Self-care доповнення до beauty-програми', 'A self-care add-on for beauty routines', false, '{"skin","beauty","aloe"}'),
  ('aloe-body-cleanse', 'personal_care', 'Aloe Body Cleanse', 'Aloe Body Cleanse', 'М’який очищувальний формат для щоденного догляду за собою.', 'A gentle cleansing format for daily personal care.', 'Використовуйте як частину спокійного ранкового або вечірнього ritual care набору.', 'Use as part of a calm morning or evening ritual care set.', 'Лише для зовнішнього використання. Слідкуйте за реакцією шкіри.', 'For external use only. Monitor your skin response.', 'body', 'https://www.foreverliving.com/', 'М’який daily care формат', 'A gentle daily care format', false, '{"self-care","daily-routine","beauty"}'),
  ('fresh-smile-gel', 'personal_care', 'Fresh Smile Gel', 'Fresh Smile Gel', 'Щоденний personal care продукт для стабільного відчуття чистоти та свіжості.', 'A daily personal care product for a consistent feeling of freshness.', 'Добре доповнює ранкову та вечірню звичку турботи про себе.', 'Complements both morning and evening self-care rituals.', 'Використовуйте за інструкцією виробника. Не призначено для медичних цілей.', 'Use according to the manufacturer instructions. Not intended for medical purposes.', 'smile', 'https://www.foreverliving.com/', 'Компактний елемент щоденної дисципліни', 'A compact part of a daily rhythm', false, '{"daily-routine","self-care"}'),
  ('aloe-reset-pack', 'combo_packs', 'Aloe Reset Pack 7', 'Aloe Reset Pack 7', 'Стартовий набір для короткої 7-денної wellness-програми з водним фокусом.', 'A starter pack for a short 7-day wellness plan focused on hydration.', 'Підійде для м’якого старту, коли потрібен готовий набір без складного вибору.', 'Useful for a gentle start when a ready-made set is easier than building one from scratch.', 'Комбо-набір не замінює індивідуальну консультацію та не дає лікувальних обіцянок.', 'A combo pack does not replace individual guidance and does not make treatment claims.', 'pack', 'https://www.foreverliving.com/', 'Готовий старт для 7-денного плану', 'A ready-made start for a 7-day plan', true, '{"combo","hydration","daily-routine"}'),
  ('aloe-glow-pack', 'combo_packs', 'Aloe Glow Pack 21', 'Aloe Glow Pack 21', 'Розширений beauty та hydration pack для більш структурованої 21-денної рутини.', 'An extended beauty and hydration pack for a more structured 21-day routine.', 'Підходить для користувачів, які хочуть мати один зібраний набір для тривалішої програми.', 'A fit for users who want a single curated set for a longer routine.', 'Залишається wellness-рішенням і не є лікувальною рекомендацією.', 'Remains a wellness option and not a treatment recommendation.', 'glow', 'https://www.foreverliving.com/', 'Розширений pack для тривалого ритму', 'An extended pack for a longer rhythm', true, '{"combo","beauty","hydration","skin"}')
on conflict (id) do update
set
  category_id = excluded.category_id,
  title_uk = excluded.title_uk,
  title_en = excluded.title_en,
  short_description_uk = excluded.short_description_uk,
  short_description_en = excluded.short_description_en,
  usage_notes_uk = excluded.usage_notes_uk,
  usage_notes_en = excluded.usage_notes_en,
  caution_notes_uk = excluded.caution_notes_uk,
  caution_notes_en = excluded.caution_notes_en,
  image_token = excluded.image_token,
  external_product_url = excluded.external_product_url,
  highlight_uk = excluded.highlight_uk,
  highlight_en = excluded.highlight_en,
  is_featured = excluded.is_featured,
  wellness_tags = excluded.wellness_tags;

insert into public.product_tag_links (product_id, tag_id)
select
  tagged.product_id,
  tags.id
from (
  values
    ('aloe-gel-classic', 'hydration'),
    ('aloe-gel-classic', 'aloe'),
    ('aloe-gel-classic', 'daily-routine'),
    ('aloe-berry-balance', 'hydration'),
    ('aloe-berry-balance', 'beauty'),
    ('aloe-berry-balance', 'aloe'),
    ('daily-shake-vanilla', 'nutrition'),
    ('daily-shake-vanilla', 'energy'),
    ('daily-shake-vanilla', 'healthy-routine'),
    ('fiber-routine-mix', 'balance'),
    ('fiber-routine-mix', 'healthy-routine'),
    ('fiber-routine-mix', 'daily-routine'),
    ('bee-pollen-daily', 'energy'),
    ('bee-pollen-daily', 'nutrition'),
    ('bee-pollen-daily', 'focus'),
    ('propolis-soft-support', 'daily-routine'),
    ('propolis-soft-support', 'balance'),
    ('propolis-soft-support', 'bee'),
    ('aloe-hydra-cream', 'beauty'),
    ('aloe-hydra-cream', 'skin'),
    ('aloe-hydra-cream', 'hydration'),
    ('aloe-soothing-gelly', 'skin'),
    ('aloe-soothing-gelly', 'beauty'),
    ('aloe-soothing-gelly', 'aloe'),
    ('aloe-body-cleanse', 'self-care'),
    ('aloe-body-cleanse', 'daily-routine'),
    ('aloe-body-cleanse', 'beauty'),
    ('fresh-smile-gel', 'daily-routine'),
    ('fresh-smile-gel', 'self-care'),
    ('aloe-reset-pack', 'combo'),
    ('aloe-reset-pack', 'hydration'),
    ('aloe-reset-pack', 'daily-routine'),
    ('aloe-glow-pack', 'combo'),
    ('aloe-glow-pack', 'beauty'),
    ('aloe-glow-pack', 'hydration'),
    ('aloe-glow-pack', 'skin')
) as tagged(product_id, tag_slug)
join public.product_tags tags on tags.slug = tagged.tag_slug
on conflict (product_id, tag_id) do nothing;

insert into public.plans (plan_code, title_uk, description_uk, duration_days, goal_keys, is_active)
values
  ('hydration-7', '7-денний hydration reset', 'М’який старт із водним фокусом, простими діями та вечірнім check-in.', 7, '{"hydration_support"}', true),
  ('balance-14', '14-денний daily balance', 'Збалансований план для щоденного rhythm support без перевантаження.', 14, '{"daily_wellness_routine","energy_support","healthy_routine_support"}', true),
  ('glow-21', '21-денний glow routine', 'Більш тривалий план із hydration, beauty та self-care акцентом.', 21, '{"beauty_skin_support","hydration_support","consistency_self_care"}', true)
on conflict (plan_code) do update
set
  title_uk = excluded.title_uk,
  description_uk = excluded.description_uk,
  duration_days = excluded.duration_days,
  goal_keys = excluded.goal_keys,
  is_active = excluded.is_active;

insert into public.plan_days (
  plan_code,
  day_number,
  title_uk,
  hydration_task_uk,
  wellness_action_uk,
  journal_prompt_uk,
  checklist_labels_uk,
  suggested_product_ids
)
values
  ('hydration-7', 1, 'День 1', 'Поставте пляшку води поруч і тримайте ритм маленькими ковтками.', 'Почніть день зі склянки води та короткого налаштування на ритм дня.', 'Що сьогодні дало вам найбільше відчуття стабільності?', '["Досягти водної цілі дня","Виконати одну wellness-дію дня","Заповнити короткий вечірній check-in"]'::jsonb, '{"aloe-gel-classic","aloe-reset-pack"}'),
  ('hydration-7', 2, 'День 2', 'Звертайте увагу на воду в першій половині дня.', 'Додайте 10 хвилин легкої прогулянки або розтяжки після обіду.', 'Що варто спростити завтра, щоб залишитися в ритмі?', '["Досягти водної цілі дня","Виконати одну wellness-дію дня","Заповнити короткий вечірній check-in"]'::jsonb, '{"aloe-berry-balance","aloe-reset-pack"}'),
  ('balance-14', 1, 'День 1', 'Почніть зі склянки води та комфортного темпу першої половини дня.', 'Заплануйте один спокійний прийом їжі без поспіху та екранів.', 'Яка звичка сьогодні спрацювала найпростіше?', '["Досягти водної цілі дня","Виконати одну wellness-дію дня","Заповнити короткий вечірній check-in"]'::jsonb, '{"daily-shake-vanilla","aloe-gel-classic"}'),
  ('balance-14', 2, 'День 2', 'Налаштуйте дві точки нагадування про воду до вечора.', 'Зробіть паузу на 3 глибокі вдихи перед головною справою дня.', 'Коли сьогодні вам було найкомфортніше фізично?', '["Досягти водної цілі дня","Виконати одну wellness-дію дня","Заповнити короткий вечірній check-in"]'::jsonb, '{"fiber-routine-mix","bee-pollen-daily"}'),
  ('glow-21', 1, 'День 1', 'Тримайте біля себе воду й зверніть увагу на відчуття шкіри та комфорту.', 'Влаштуйте один маленький self-care ритуал увечері.', 'Який настрій ви хочете перенести у завтрашній день?', '["Досягти водної цілі дня","Виконати одну wellness-дію дня","Заповнити короткий вечірній check-in"]'::jsonb, '{"aloe-hydra-cream","aloe-glow-pack"}'),
  ('glow-21', 2, 'День 2', 'Слідкуйте за рівним споживанням води впродовж дня.', 'Перевірте, чи є у вас під рукою пляшка води на другу половину дня.', 'Що ви хочете повторити завтра без зайвого тиску?', '["Досягти водної цілі дня","Виконати одну wellness-дію дня","Заповнити короткий вечірній check-in"]'::jsonb, '{"aloe-soothing-gelly","aloe-glow-pack"}')
on conflict (plan_code, day_number) do update
set
  title_uk = excluded.title_uk,
  hydration_task_uk = excluded.hydration_task_uk,
  wellness_action_uk = excluded.wellness_action_uk,
  journal_prompt_uk = excluded.journal_prompt_uk,
  checklist_labels_uk = excluded.checklist_labels_uk,
  suggested_product_ids = excluded.suggested_product_ids;

insert into public.app_config (key, value, is_active)
values
  ('shop_base_url', '"https://www.foreverliving.com/"'::jsonb, true),
  ('support_email', '"support@aloewellnesscoach.app"'::jsonb, true),
  ('enable_ai_coach', 'false'::jsonb, true),
  ('highlight_message', '"Рухайтесь у власному темпі: вода, сон і м’яка щоденна послідовність."'::jsonb, true)
on conflict (key) do update
set
  value = excluded.value,
  is_active = excluded.is_active;
