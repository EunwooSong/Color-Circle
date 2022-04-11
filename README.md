# Color-Circle
Assignment - Color Circle / Art & Technology(다)

![AssinmentPlay](./Play-Color-Circle.gif)

## About Project
 - 벽돌깨기 게임을 개발하며 색이 변화하는 공에 영감을 얻어 제작하게 되었습니다.
 - 회전하는 색상 공들을 눌러 색상 코드와 색조 값을 확인 할 수 있습니다.
 - 유동적인 프레임에 대응하기 위해 프레임별 시간 차이인 deltaTime를 구해서 사용했습니다.
 - `void setup`에서 `objCount`의 값을 변경하면 더욱 다양한 색을 확인할 수 있습니다.
 - 부드러운 에니메이션 효과를 위해 선형보간방법을 사용하였다.
   - Lerp(A, B, alpha) { A * (1 - Alpha) + B * Alpha}
 - 가운데 색상 공이 커질 때 주변 공 회전에 가속을 주는 효과를 추가해 ~~그럴싸하게~~ 만들었습니다.
 - 공의 중심과 마우스 커서와의 거리를 계산해 상호작용을 구현하였습니다. (dist < objRad...)