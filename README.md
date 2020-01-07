# GifMaker_Swift
video 파일을 GIF파일로 변환하는 앱 </br>
### Index
- [기능](#기능)
- [설계 및 구현](#설계-및-구현)
- [trouble shooting](#trouble-shooting)
- [학습한 내용](#관련-학습-내용)

## 기능 
- [비디오파일 GIF로 변환](#비디오파일-GIF로-변환)
- [캡션 삽입](#캡션-삽입)
- [GIF 공유하기](#GIF-공유하기)
- [앨범의 비디오를 GIF로 변환](#앨범의-비디오를-GIF로-변환)
- [추가기능-편집](#추가기능-편집)

### 비디오파일 GIF로 변환
- 카메라 열기와 저장된 비디오 검색
- 비디오파일에서 GIF 파일로 변환하기
- UIImageView에 GIF로 보여주기

### 캡션 삽입
- Gif 클래스 생성
- Gif 에디터에서 캡션 텍스트에 키보드 처리 (보이기, 숨기기) 만들기
- gif 컴포넌트 이미지에 캡션을 추가하기

### GIF 공유하기
- UIActivityController를 열어서 사용자가 선택하여 파일을 공유할 수 있음 

### 앨범의 비디오를 GIF로 변환
- launchVideoCamera() 함수 호출시 3가지 옵션을 선택하는 Action sheet 만들기 
   - function : `recordVideo(), chooseFromexisting(), cancel()`
- 포토 앨범 실행하기

### 추가기능-편집
- 사용자가 변환 전에 비디오 다듬을 수 있도록 허용
- GIF가 정사각형이 되도록 제한
