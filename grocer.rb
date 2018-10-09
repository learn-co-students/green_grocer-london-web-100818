require 'pry'

def consolidate_cart(cart)
  new_hash = {}
  cart.each do |hash|
    hash.each do |item, info|
      if(new_hash.has_key?(item))
        new_hash[item][:count] = new_hash[item][:count] + 1
      else
        new_hash[item], new_hash[item][:count] = info, 1
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
      if(cart.has_key?(coupon[:item]) && !cart.has_key?("#{coupon[:item].upcase} W/COUPON"))
        if(coupon[:num] <= cart[coupon[:item]][:count])
          cart["#{coupon[:item].upcase} W/COUPON"] = {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance], count: 1}
          cart["#{coupon[:item]}"][:count] = cart["#{coupon[:item]}"][:count] - coupon[:num]
        end
      elsif(cart.has_key?(coupon[:item]) && cart.has_key?("#{coupon[:item].upcase} W/COUPON"))
        if(coupon[:num] <= cart[coupon[:item]][:count])
          cart["#{coupon[:item].upcase} W/COUPON"][:count] = cart["#{coupon[:item].upcase} W/COUPON"][:count] + 1
          cart["#{coupon[:item]}"][:count] = cart["#{coupon[:item]}"][:count] - coupon[:num]
        end
      end
  end
  cart
end

def apply_clearance(cart)
  cart.collect do |item, info|
    if(info[:clearance])
      info[:price] = (info[:price] * 0.8).round(1)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)

  discounted_cart = apply_clearance(couponed_cart)
  sum = 0
  discounted_cart.each {|item, info|
    sum += (discounted_cart[item][:price] * discounted_cart[item][:count])
  }
  if(sum > 100)
    sum = sum * 0.9
  end
  sum
end
