require 'pry';

def consolidate_cart(cart)
  # code here
  cart.each_with_object({}) { |hash, updated_cart|
    hash.each { |item, details|
      if updated_cart[item]
        details[:count] += 1
      else
        updated_cart[item] = details
        details[:count] = 1
      end
    }
  }
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each { |coupon|
    item = coupon[:item]
    item_coupon = "#{item} W/COUPON"
    if cart[item] && cart[item][:count] >= coupon[:num]
      if cart[item_coupon]
        cart[item_coupon][:count] += 1
      else
        cart[item_coupon] = {
          price: coupon[:cost],
          clearance: cart[item][:clearance],
          count: 1
        }
      end
      cart[item][:count] -= coupon[:num]
    end
  }
  cart
end

def apply_clearance(cart)
  # code here
  cart.each { |item, details|
    if details[:clearance] == true
      clearance_price = details[:price] * 0.8
      details[:price] = clearance_price.round(2)
    end
  }
  cart
end

def checkout(cart, coupons)
  # code here
  updated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(updated_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  cart_total = 0

  clearance_cart.each { |item, details|
    cart_total += details[:price] * details[:count]
  }

  if cart_total > 100
    cart_total *= 0.9
  else
    cart_total
  end
end
