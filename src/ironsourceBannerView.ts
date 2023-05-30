import {
  requireNativeComponent,
  UIManager,
  Platform,
  ViewStyle,
} from 'react-native'

const LINKING_ERROR =
  `The package 'react-native-ironsource-advanced' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n'

type BannerViewProps = {
  style?: ViewStyle
}

const ComponentName = 'IronsourceBannerView'

export default UIManager.getViewManagerConfig(ComponentName) != null
  ? requireNativeComponent<BannerViewProps>(ComponentName)
  : () => {
      throw new Error(LINKING_ERROR)
    }
