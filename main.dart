import 'dart:async';
import 'dart:html';
import 'dart:math';

List<ButtonElement> buttons = List();
List<ButtonElement> target = List();
Element tile;
Element textScore;
int score = 0;
int row = 3;
int column = 4;

Future main() async{
  tile = querySelector('#tile');
  textScore = querySelector('#score');
  Element test = querySelector('#res')..onClick.listen(RestartButton);
  querySelectorAll('.sizeG')..onClick.listen(ChangeButton);
  AddButton();
  }

void OpenButton(Event e){
  score++;
  textScore.text = "Очки: $score";

  if(target.length < 2){ //Проверям сколько нажато кнопок
    for(var b in buttons){ //Получаем нажатую кнопку и заносим в список
      if(e.target == b){
        target.add(b);
      }
    }
    for(var t in target){ //Меняем цвет нажатой кнопки и деактивируем
      t.disabled = true;
      t.style..backgroundColor = 'red'..color = "#fff";
    }
  } 

  if(target[0].text == target[1].text){ //Если нажато две кнопки и они совпадают
    for(var t in target){
        t.style..backgroundColor = 'green'..transform = 'none';
        buttons.remove(t);
      }
      target.clear();
  }else { //Если выбраны не правильные
    for(var b in buttons){
      b.disabled = true;
    }
    startTimer();
  }
}

const timeOut = Duration(seconds: 1);
const ms = Duration(milliseconds: 1);
startTimer([int milleseconds]){
  var duration = milleseconds == null ? timeOut : ms * milleseconds;
  return Timer(duration, DisableButton);
}

void DisableButton(){
  for(var b in buttons){
    b.disabled = false;
  }
  for(var t in target){
    t.style..backgroundColor = '#adadad'..color = "#adadad";
  }
  target.clear();
}

void RestartButton(Event e){  
  AddButton();
}

void AddButton(){
  DisableButton();
  int a = 0;
  List<TableRowElement> tr = List()..add(TableRowElement());
  Random random = Random();
  List<int> number = List(); 
  List<int> rand = List();
  bool yes = false;
  tile.children.clear();
  tile.children.add(tr[a]);
  score = 0;
  textScore.text = "Очки: 0";

  for(int i = 0; i < row * column / 2; i++){
    yes = false;
    int r = random.nextInt(100);
    for(int j = 0; j < rand.length; j++){
      if (r == rand[j]){
        yes = true;
        break;
      }
    } 
    if(yes){
      i--;
      continue;
    }   
    rand.add(r);    
  }
  number.addAll(rand);
  number.addAll(rand);
 
  for(int i = 0; i < row * column; i++){
    buttons.add(ButtonElement());    
    buttons[i]..classes.add("BG")..addEventListener('click', OpenButton);

    switch (row){
      case 4: buttons[i].style..height = '85px'..width = '85px'..margin = '4px'; break;
      case 6: buttons[i].style..height = '70px'..width = '70px'..margin = '3px'; break;
      default: buttons[i].style..height = '100px'..width = '100px'..margin = '5px'; break;
    }

    int n = random.nextInt(number.length);
    buttons[i].text = number[n].toString();
    number.remove(number[n]);

    tr[a].children.add(buttons[i]);
    if(tr[a].children.length >= column && i + 1 != row*column){
      a++;
      tr.add(TableRowElement());
      tile.children.add(tr[a]);
    }
  }
}

void ChangeButton(Event e){
  AnchorElement b = e.target;
  row = int.parse(b.text.split('x')[0]);
  column = int.parse(b.text.split('x')[1]);
  AddButton();
}