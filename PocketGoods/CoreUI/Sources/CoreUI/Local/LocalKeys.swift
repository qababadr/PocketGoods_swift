//
//  LocalKeys.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//
import Foundation

extension String {
    public func localized(
        bundle: Bundle = .main,
        comment: String = "",
        _ arguments: any CVarArg...
    ) -> String {
        return String(
            format: NSLocalizedString(
                self,
                bundle: bundle,
                comment: comment
            ),
            arguments: arguments
        )
    }
}

public struct LocalKeys {
    public static let appName = "app_name"
    public static let headerText = "header_Text"
    public static let lblDiscount = "lbl_discount"
    public static let themeSwitch = "cd_theme_switch"
    public static let checkedDarkThemeIcon = "cd_checked_icon"
    public static let notFoundText = "text_404"
    public static let returnHome = "back_home"
    public static let unauthorizedText = "text_401"
    public static let learnMore = "learn_more"
    public static let errorFetchingData = "err_fetching_data"
    public static let cdErrorFetching = "cd_error_fetching"
    public static let price = "lbl_price"
    public static let description = "lbl_description"
    public static let leftInStock = "lbl_left_in_stock"
    public static let category = "lbl_category"
    public static let removeFromWishlistCd = "cd_remove_from_wishlist"
    public static let addToWishlistCd = "cd_add_to_wishlist"
    public static let removeFromWishlistLabel = "lbl_remove_from_wishlist"
    public static let addToWishlistLabel = "lbl_add_to_wishlist"
    public static let email = "lbl_email"
    public static let password = "lbl_password"
    public static let registerNow = "lbl_register_now"
    public static let close = "lbl_close"
    public static let login = "lbl_login"
    public static let wrongLoginCredentials = "txt_wrong_login_credentials"
    public static let fullName = "lbl_first_and_last_name"
    public static let fullNameError = "err_fullName_validation_error"
    public static let emailError = "err_email_validation_error"
    public static let passwordError = "err_password_validation_error"
    public static let confirmPassword = "lbl_confirm_password"
    public static let confirmPasswordError =
        "err_confirm_password_validation_error"
    public static let alreadyRegistered = "lbl_already_registered"
    public static let register = "lbl_register"
    public static let registered = "txt_registered"
    public static let registrationError = "err_registration"
    public static let myWishlist = "lbl_my_wishlist"
    public static let switchTheme = "lbl_switch_theme"
    public static let logout = "lbl_logout"
    public static let passwordRequired = "err_password_required"
    public static let emptyWishlist = "txt_empty_wishlist"
    public static let outOfStock = "lbl_out_of_stock"
    public static let delete = "lbl_delete"
    public static let confirmation = "lbl_confirmation"
    public static let wishlistDeletionPart1 =
        "txt_wishlist_deletion_confirmation_pt_1"
    public static let wishlistDeletionPart2 =
        "txt_wishlist_deletion_confirmation_pt_2"
    public static let copyRight = "txt_copy_right"
    public static let search = "lbl_search"
    public static let clearSearchCd = "cd_clear_search"
    public static let searchProductsCd = "cd_search_products"
    public static let loggedOut = "txt_logged_out"
    public static let loggedOutError = "err_logged_out"
    public static let loggedIn = "txt_logged_in"
    public static let refreshUserDataError = "err_refresh_user_data"
    public static let unauthenticated = "txt_unauthenticated"
    public static let addedToWishlist = "txt_added_to_wishlist"
    public static let removedFromWishlist = "txt_removed_from_wishlist"
    public static let removeFromWishlistError = "err_remove_from_wishlist"
    public static let imageCd = "cd_image"
    public static let productCardCd = "cd_product_card"
    public static let priceValue = "lbl_price_value"
    public static let learnMoreButtonCd = "cd_button_learn_more"
    public static let toolbarLoginCd = "cd_toolbar_login"
    public static let toolbarUserMenuCd = "cd_toolbar_user_menu"
    public static let userMenuContainer = "user_menu_container"
    public static let loginButtonCd = "cd_button_login"
    public static let registerNowCd = "cd_register_now"
    public static let registerButtonCd = "cd_button_register"
    public static let toggleWishlistCd = "cd_toggle_wishlist"
    public static let productCardImageButtonCd = "cd_product_card_image_button"
    public static let productInWishlistCd = "cd_product_in_wishlist"
    public static let productNotInWishlistCd = "cd_product_not_in_wishlist"
    public static let wishlistUserMenuCd = "cd_wishlist_user_menu"
    public static let switchThemeUserMenuCd = "cd_switch_theme_user_menu"
    public static let deleteWishlistItemCd = "cd_delete_wishlist_item"
    public static let openDeleteModalCd = "cd_open_delete_modal"
    public static let uncheckedDarkThemeIconCd = "cd_unchecked_icon"
    public static let searchInputListTestTagCd = "cd_search_input_list_test_tag"
    public static let suggestedProductCd = "cd_suggested_product"
    public static let searchInputSearchButtonCd =
        "cd_search_input_search_button"
    public static let emptyProductList = "txt_empty_product_list"
    public static let txtCopyRight = "txt_copy_right"
    public static let txt404 = "text_404"
    public static let searchInputLoadingIndicatorCd =
        "search_input_loading_indicator_cd"
    public static let productPriceCd = "product_price_cd"
    public static let passwordVisibleToggleCd = "password_visible_toggle_cd"
    public static let conformPasswordVisibleToggleCd =
        "confirm_password_visible_toggle_cd"
}
